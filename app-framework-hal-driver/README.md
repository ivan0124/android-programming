# App-Framework-HAL-Driver
This is a sample code. (test on Qualcomm MSM8953)

# Code Description
1. install driver, hello_init() is called: [hello.c](https://github.com/ivan0124/Linux-programming/blob/master/driver_hello/hello.c)
<pre>
static int hello_init(void) {
        printk("<1>hello_driver: init\n");
...
}
...
module_init(hello_init);
</pre>
2.  uninstall driver, hello_exit() is called:  [hello.c](https://github.com/ivan0124/Linux-programming/blob/master/driver_hello/hello.c)
<pre>
static void hello_exit(void) {
        printk("<1>hello_driver: exit\n");
}
...
module_exit(hello_exit);
</pre>

# How To Test 
1.Typing `make` to build code

2.install driver
<pre>
$ sudo insmod ./hello.ko
</pre>
3.check the printk() log by typing `dmesg`
<pre>you will see "<1>hello_driver: init" in log </pre>

4.uninstall driver
<pre>
$ sudo rmmod hello
</pre>
5.check the printk() log by typing `dmesg`
<pre>you will see "<1>hello_driver: exit" in log</pre>
