//usr/bin/env go run "$0" "$@" ; exit "$?"

package main

import "time"
import "fmt"
import "os"

func main() {
	fmt.Println("Hello World! It's all a bit tiring.")
	time.Sleep(5 * time.Second)
	fmt.Println("Goodbye World!")
	os.Exit(1)
}
