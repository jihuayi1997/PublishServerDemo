package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"bufio"
	"os/exec"
	"io/ioutil"
)

func main()  {
	http.HandleFunc("/", index)
	http.HandleFunc("/publish", publish)
	http.HandleFunc("/update", update)
	http.HandleFunc("/switchqa", switchqa)
	http.HandleFunc("/switchmaster", switchmaster)
	err := http.ListenAndServe(":9090", nil)
	if err != nil {
		fmt.Println("服务器启动失败", err.Error())
	return
	}
}

func update(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-p","all"}
		cmd := exec.Command(shellPath, params...)

	//显示运行的命令
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

	//fmt.Println("ProcessState PID:", cmd.ProcessState.Pid())
	fmt.Fprintln(writer, "ezlib dependence sdk launcher updated!")
	}
}

func switchqa(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-c","qa"}
		cmd := exec.Command(shellPath, params...)

	//显示运行的命令
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

	//fmt.Println("ProcessState PID:", cmd.ProcessState.Pid())
	fmt.Fprintln(writer, "Switched to QA: sdk,launcher!")
	}
}

func switchmaster(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-c","master"}
		cmd := exec.Command(shellPath, params...)

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

	//fmt.Println("ProcessState PID:", cmd.ProcessState.Pid())
	fmt.Fprintln(writer, "Switched to master: sdk,launcher!")
	}
}

func index(writer http.ResponseWriter, request *http.Request) {
	data, err := ioutil.ReadFile("publish.html")
	if err != nil{
		fmt.Println("read html file failed,err", err)
		return
	}
	writer.Write(data)
}

func publish(writer http.ResponseWriter, request *http.Request) {
	request.ParseForm()
	version := request.Form.Get("version")
	software := request.Form.Get("software")
	branch := request.Form.Get("branch")
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\publish.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"publish.sh",software,branch,version}
		cmd := exec.Command(shellPath, params...)

	//显示运行的命令
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

	//fmt.Println("ProcessState PID:", cmd.ProcessState.Pid())
	fmt.Fprintln(writer, "Publish done!")
	}
}