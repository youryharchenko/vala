package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"sync"
	"syscall"
	"time"
)

var wg sync.WaitGroup

var sock = flag.String("sock", "", "Sock file pathname")

func main() {

	flag.Parse()

	fmt.Println("Sock:", *sock)

	defer func() {
		fmt.Println("quit")
		time.Sleep(time.Second)
		os.Exit(0)
	}()

	syscall.Unlink(*sock)

	server, err := net.Listen("unix", *sock)
	if err != nil {
		fmt.Println("Listen error:", err)
		return
	}

	defer server.Close()

	fmt.Println("ready to connect")

	wg.Add(1)
	go func() {
		defer wg.Done()

		for {
			conn, err := server.Accept()
			if err != nil {
				log.Println("Accept error:", err)
				continue
			}

			log.Println("Accepted!")
			//in := make(chan string)

			go func(c net.Conn) {

				buf := make([]byte, 512)
				nr, err := c.Read(buf)
				if err != nil {
					log.Println("Read error:", err)
					return
				}

				data := buf[0:nr]
				log.Println("Echo: " + string(data))
				//in <- string(data)

				c.Write([]byte("OK\n"))

			}(conn)
		}
	}()

	wg.Add(1)
	go func() {
		defer wg.Done()

		var n = 0
		for {
			time.Sleep(time.Second * 10)
			log.Println("tick", n)
			n++
		}

	}()

	wg.Wait()
}
