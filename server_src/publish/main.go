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
	http.HandleFunc("/launchermaster", launchermaster)
	http.HandleFunc("/launcherqa", launcherqa)
	http.HandleFunc("/sdkmaster", sdkmaster)
	http.HandleFunc("/sdkqa", sdkqa)
	http.HandleFunc("/launchervg", launchervg)
	http.HandleFunc("/dep", dep)
	http.HandleFunc("/demo", demo)
	err := http.ListenAndServe(":9090", nil)
	if err != nil {
		fmt.Println("服务器启动失败", err.Error())
	return
	}
}

func launcherqa(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-d","qa"}
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
	fmt.Fprintln(writer, "Launcher switched to qa, all updated!")
	}
}

func sdkqa(writer http.ResponseWriter, request *http.Request) {
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
	fmt.Fprintln(writer, "SDK switched to qa, all updated!")
	}
}

func launchervg(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-d","vg"}
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
	fmt.Fprintln(writer, "Launcher switched to vg, all updated!")
	}
}

func sdkmaster(writer http.ResponseWriter, request *http.Request) {
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
	fmt.Fprintln(writer, "SDK switched to master, all updated!")
	}
}

func launchermaster(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-d","master"}
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
	fmt.Fprintln(writer, "Launcher switched to master, all updated!")
	}
}

func dep(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		//command := "csigntool.exe"
		shellPath := "git-bash.exe"
		//params := []string{"sign","/r","SDK","/f","\"D:\\Cerberus\\npl-publish\\tools\\uploadfile\\"+handler.Filename+"\""}
		params := []string{"auto.sh","-p","dep"}
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
	fmt.Fprintln(writer, "Ezlib, Dependence updated!")
	}
}

func demo(writer http.ResponseWriter, request *http.Request) {
	flag := true
	if _, err := os.Stat("D:\\Cerberus\\npl-publish\\auto.sh"); os.IsNotExist(err) {
		flag = false
	}

	if flag==true{
		shellPath := "git-bash.exe"
		cmd := exec.Command(shellPath, "Jzip.sh")

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
	fmt.Fprintln(writer, "Demo published!")
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
	fmt.Fprintln(writer, "Publish done! You can see if it is successfully published in the log!")
	}
}