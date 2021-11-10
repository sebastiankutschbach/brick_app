package main

import (
	"encoding/csv"
	"io"
)

func ParseCsv(r io.Reader) (data [][]string, err error) {
	data, err = csv.NewReader(r).ReadAll()
	if err != nil {
		return
	}

	return data[1:], nil
}
