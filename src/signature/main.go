package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"bufio"
	"os/exec"
)

func main() {
	http.HandleFunc("/", index)
	http.HandleFunc("/upload2", upload)
	err := http.ListenAndServe(":8086", nil)
	if err != nil {
		fmt.Println("服务器启动失败", err.Error())
	return
	}
}

func upload(writer http.ResponseWriter, request *http.Request) {
	request.ParseMultipartForm(32 << 20)
	//接收客户端传来的文件 upoadfile 与客户端保持一致
	file, handler, err := request.FormFile("uploadfile")
	if err != nil {
		fmt.Println(err)
		return
	}
	
	//ext := path.Ext(handler.Filename) //获取文件后缀
	//fileNewName := string(time.Now().Format("20060102150405")) + strconv.Itoa(time.Now()Nanosecond()) + ext

	f, err := os.OpenFile("./uploadfile/"+handler.Filename, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
	return
	}

	
	io.Copy(f, file)
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		defer file.Close()
		f.Close()
		//command := "csigntool.exe"
		command := "csigntool.cmd"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"./uploadfile/"+handler.Filename}
		cmd := exec.Command(command, params...)

	//显示运行的命令
	fmt.Fprintln(writer, cmd.Args)
	fmt.Println(cmd.Args)

	stdout, err := cmd.StdoutPipe()

	if err != nil {
		fmt.Fprintln(writer, err)
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
		fmt.Fprintln(writer, line)
		fmt.Println(line)
	}

	cmd.Wait()
	fmt.Fprintln(writer, "All done!"+handler.Filename)
	fmt.Fprintln(writer, "Now you can choose to continue uploading & signing or choose to download.")
	}
}

func index(writer http.ResponseWriter, request *http.Request) {
	writer.Write([]byte(tpl))
}

const tpl = `<html>
<head>
<title>上传文件</title>
</head>
<body>
<form enctype="multipart/form-data" action="/upload2" method="post">
<input type="file" name="uploadfile">
<input type="hidden" name="token" value="{...{.}...}">
<input type="submit" value="upload">
</form>
</body>
</html>`
