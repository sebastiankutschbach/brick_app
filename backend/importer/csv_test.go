package main

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseCsv(t *testing.T) {
	in, err := os.Open("./testdata/themes.csv")
	if err != nil {
		t.Log("Failed to open the test file. Error:", err)
		t.Fail()
	}

	data, err := ParseCsv(in)
	if err != nil {
		t.Log("Failed to parse the test file. Error:", err)
		t.Fail()
	}

	assert.Greater(t, len(data), 1)
	assert.NotEqual(t, data[0][0], "id")
}
