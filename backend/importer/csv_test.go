package main

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseCsvHeader(t *testing.T) {
	in, err := os.Open("./testdata/themes.csv")
	if err != nil {
		t.Log("Failed to open the test file. Error:", err)
		t.Fail()
	}

	header, _, err := ParseCsv(in)
	if err != nil {
		t.Log("Failed to parse the test file. Error:", err)
		t.Fail()
	}

	assert.Equal(t, len(header), 3)
	assert.Equal(t, header[0], "id")
	assert.Equal(t, header[1], "name")
	assert.Equal(t, header[2], "parent_id")
}

func TestParseCsvData(t *testing.T) {
	in, err := os.Open("./testdata/themes.csv")
	if err != nil {
		t.Log("Failed to open the test file. Error:", err)
		t.Fail()
	}

	_, data, err := ParseCsv(in)
	if err != nil {
		t.Log("Failed to parse the test file. Error:", err)
		t.Fail()
	}

	assert.Greater(t, len(data), 1)
	assert.NotEqual(t, data[0][0], "id")
}
