package main

import (
	"io/ioutil"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestUntar(t *testing.T) {
	in, err := ioutil.ReadFile("./testdata/themes.csv.gz")
	if err != nil {
		t.Log("Failed to open the test file. Error:", err)
		t.Fail()
	}

	out, err := os.Create("./output/themes.csv")
	if err != nil {
		t.Log("Failed to open the output file. Error:", err)
		t.Fail()
	}
	defer os.Remove(out.Name())

	err = Gunzip(out, in)
	if err != nil {
		t.Log("Failed to untar the test file. Error:", err)
		t.Fail()
	}

	assert.FileExists(t, "./output/themes.csv")

}
