package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"io/ioutil"
	"strings"
	"github.com/aymerick/raymond"
	"github.com/ghodss/yaml"
	yamlv2 "gopkg.in/yaml.v2"
	flag "github.com/spf13/pflag"
)

type TemplateVariables map[string]interface{}

type Config struct {
	Resource           string
	Variables          []string
	VariablesFile      string
}

func InitConfig(cfg *Config) {
	flag.ErrHelp = fmt.Errorf("\ndeploy prepares Kubernetes resources.\n")
	flag.StringVar(&cfg.Resource, "resource", os.Getenv("RESOURCE"), "File with Kubernetes resource. Can be specified multiple times. (env RESOURCE)")
	flag.StringSliceVar(&cfg.Variables, "var", getEnvStringSlice("VAR"), "Template variable in the form KEY=VALUE. Can be specified multiple times. (env VAR)")
	flag.StringVar(&cfg.VariablesFile, "vars", os.Getenv("VARS"), "File containing template variables. (env VARS)")
	flag.Parse()
}

func main() {
	var err error
	
	fmt.Println("Initializing documentation process")

	var templateVariables = make(TemplateVariables)
	var cfg = new(Config)
	InitConfig(cfg)

	if len(cfg.Resource) == 0 {
		fmt.Println("No nais resource provided. Exiting documentation")
		return
	}

	if len(cfg.VariablesFile) > 0 {
		fmt.Println("Loading template variables from file")
		templateVariables, err = templateVariablesFromFile(cfg.VariablesFile)
		if err != nil {
			fmt.Println("load template variables: %s", err)
		}
	}

	if len(cfg.Variables) > 0 {
		fmt.Println("Loading template variables from string")
		templateOverrides := templateVariablesFromSlice(cfg.Variables)
		for key, val := range templateOverrides {
			if oldval, ok := templateVariables[key]; ok {
				fmt.Println("Overwriting template variable '%s'; previous value was '%v'", key, oldval)
			}
			fmt.Println("Setting template variable '%s' to '%v'", key, val)
			templateVariables[key] = val
		}
	}
		
	fmt.Println("Merging template var with resource")
	parsed, err := MultiDocumentFileAsJSON(cfg.Resource, templateVariables)
	if err != nil {fmt.Println(err)}

	fmt.Println("Converting yml to json")
	var js, err2 = json.Marshal(parsed)
	if err2 != nil {fmt.Println(err)}

	fmt.Println("Writing to tmp file: %v",string(js))
	ioutil.WriteFile("tmp.json", js, 0644)
	fmt.Println("Done.")
}


func templateVariablesFromFile(path string) (TemplateVariables, error) {
	var err error
	file, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("%s: open file: %s", path, err)
	}

	vars := TemplateVariables{}
	err = yaml.Unmarshal(file, &vars)

	return vars, err
}

func templateVariablesFromSlice(vars []string) TemplateVariables {
	tv := TemplateVariables{}
	for _, keyval := range vars {
		tokens := strings.SplitN(keyval, "=", 2)
		switch len(tokens) {
		case 2: // KEY=VAL
			tv[tokens[0]] = tokens[1]
		case 1: // KEY
			tv[tokens[0]] = true
		default:
			continue
		}
	}

	return tv
}



func MultiDocumentFileAsJSON(path string, ctx TemplateVariables) ([]json.RawMessage, error) {
	file, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("%s: open file: %s", path, err)
	}

	templated, err := templatedFile(file, ctx)
	if err != nil {
		errMsg := strings.ReplaceAll(err.Error(), "\n", ": ")
		return nil, fmt.Errorf("%s: %s", path, errMsg)
	}

	var content interface{}
	messages := make([]json.RawMessage, 0)

	decoder := yamlv2.NewDecoder(bytes.NewReader(templated))
	for {
		err = decoder.Decode(&content)
		if err == io.EOF {
			err = nil
			break
		} else if err != nil {
			return nil, err
		}

		rawdocument, err := yamlv2.Marshal(content)
		if err != nil {
			return nil, err
		}

		data, err := yaml.YAMLToJSON(rawdocument)
		if err != nil {
			errMsg := strings.ReplaceAll(err.Error(), "\n", ": ")
			return nil, fmt.Errorf("%s: %s", path, errMsg)
		}

		messages = append(messages, data)
	}

	return messages, err
}



func templatedFile(data []byte, ctx TemplateVariables) ([]byte, error) {
	if len(ctx) == 0 {
		return data, nil
	}
	template, err := raymond.Parse(string(data))
	if err != nil {
		return nil, fmt.Errorf("parse template file: %s", err)
	}

	output, err := template.Exec(ctx)
	if err != nil {
		return nil, fmt.Errorf("execute template: %s", err)
	}

	return []byte(output), nil
}


func getEnvStringSlice(key string) []string {
	if value, ok := os.LookupEnv(key); ok {
		return strings.Split(value, ",")
	}

	return []string{}
}
