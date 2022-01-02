package main

import (
	"fmt"
	"time"
	"wk05/pkg"
)

func main() {
	sw := pkg.NewSlidingWindow()
	for _, i := range []int{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} {
		sw.Increment(i)
		sum := sw.Sum()
		fmt.Printf("ts=%v; sum=%d\n", time.Now().Unix(), sum)
		time.Sleep(1 * time.Second)
	}
}
