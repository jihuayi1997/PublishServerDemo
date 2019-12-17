package main

import (
    "io"
    "os"
    "fmt"
    "io/ioutil"
	"net/http"
	"os/exec"
	"bufio"
)

func uploadHandler(w http.ResponseWriter, r *http.Request) {
    reader, err := r.MultipartReader()
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    for {
        part, err := reader.NextPart()
        if err == io.EOF {
            break
        }

        fmt.Printf("FileName=[%s]\n", part.FileName())
        if part.FileName() == "" {  // this is FormData
            data, _ := ioutil.ReadAll(part)
            fmt.Printf("FormData=[%s]\n", string(data))
        } else {    // This is FileData
            dst, _ := os.Create("./uploadfile/" + part.FileName())
            defer dst.Close()
			io.Copy(dst, part)
			flag := true
			if _, err := os.Stat("D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+part.FileName()); os.IsNotExist(err) {
			flag = false
				}

			if flag==true{
			dst.Close()
			//command := "csigntool.exe"
			command := "csigntool.cmd"
			//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
			params := []string{"./uploadfile/"+part.FileName()}
			cmd := exec.Command(command, params...)

			//显示运行的命令
			fmt.Fprintln(w, cmd.Args)
			fmt.Println(cmd.Args)
			stdout, err := cmd.StdoutPipe()

			if err != nil {
				fmt.Println(err)
			}
	
			cmd.Start()

			reader := bufio.NewReader(stdout)

			//实时循环读取输出流中的一行内容
			for {
				line, err2 := reader.ReadString('\n')
				if err2 != nil || io.EOF == err2 {
					break
				}
				fmt.Println(line)
			}
			cmd.Wait()
			}
       	 }
	}
	
}

func main() {
    http.HandleFunc("/upload", uploadHandler)
    http.ListenAndServe(":8888", nil)
}