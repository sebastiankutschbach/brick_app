package main

import (
	"io/ioutil"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestUntar(t *testing.T) {
	csvFilePath := "./output/themes.csv"

	in, err := ioutil.ReadFile("./testdata/themes.csv.gz")
	if err != nil {
		t.Log("Failed to open the test file. Error:", err)
		t.Fail()
	}

	out, err := os.Create(csvFilePath)
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

	assert.FileExists(t, csvFilePath)
	stat, err := os.Stat(csvFilePath)
	if err != nil {
		t.Log("Failed to untar the test file. Error:", err)
		t.Fail()
	}
	print(stat.Size())
	assert.True(t, stat.Size() != 0)

}
