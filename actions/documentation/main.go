package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"strings"
	"github.com/aymerick/raymond"
	"github.com/ghodss/yaml"
	yamlv2 "gopkg.in/yaml.v2"
)

type TemplateVariables map[string]interface{}



func main() {
	var err error
	var templateVariables = make(TemplateVariables)
	
	templateVariables, err = templateVariablesFromFile("./naiserator-dev.json")
	if err != nil {fmt.Println(err)}

	parsed, err := MultiDocumentFileAsJSON("naiserator.yml", templateVariables)
	if err != nil {fmt.Println(err)}

	var js, err2 = json.Marshal(parsed)
	if err2 != nil {fmt.Println(err)}

	fmt.Println("From GO: writing %v",string(js))
	_ = ioutil.WriteFile("tmp.json", js, 0644)
	file, _ := ioutil.ReadFile("tmp.json")
	fmt.Println("From GO: reading %v",string(file))
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

