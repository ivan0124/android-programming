# App-Framework-HAL-Driver
This is a sample code. (test on Qualcomm MSM8953)

# Driver Code Description
Step1: add ~/android/kernel/msm-3.18/drivers/misc/[circular-char.c](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/kernel/msm-3.18/drivers/misc/circular-char.c)

Step2: the following code is added to [Makefile](https://github.com/ivan0124/android-programming/blob/master/app-framework-hal-driver/android/kernel/msm-3.18/drivers/misc/Makefile)
<pre>
#opersys1
obj-y += circular-char.o
#opersys1
</pre>

Step3: Using the following instruction to verify that driver work
<pre>
$ echo hello > dev/circchar
$ cat dev/circchar
#will see the hello
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
