package main

import (
	"bytes"
	"compress/gzip"
	"io"
	"io/ioutil"
)

func Gunzip(w io.Writer, data []byte) (err error) {
	gr, err := gzip.NewReader(bytes.NewBuffer(data))
	if err != nil {
		return err
	}
	defer gr.Close()
	data, err = ioutil.ReadAll(gr)
	if err != nil {
		return err
	}
	w.Write(data)
	return nil
}
