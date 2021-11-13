package main

import (
	"encoding/csv"
	"io"
)

func ParseCsv(r io.Reader) (header []string, data [][]string, err error) {
	data, err = csv.NewReader(r).ReadAll()
	if err != nil || len(data) == 0 {
		return
	}

	return data[0], data[1:], nil
}
