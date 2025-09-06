---
title: Kernel Mode, Cybersecurity and Rust
date: 2025-09-06
---

Since last year, I have been working in cybersecurity. I mostly worked on the data ingestion side of things, but lately I started working on the agents that run on user machines. I want to take this opportunity to write a little bit about User Space and Kernel Space, but before jumping into it, let me explain the macro view of a cybersecurity product like EDR (Endpoint Detection and Response).

First, what is EDR? Well, corporations don't want their information to leak, and a common attack is through employees' laptops (endpoints). In a way, you can think of an EDR as a system that monitors endpoints and tries to respond to malware and other cyber threats. To do that, it needs to look at your computer activities and categorise actions as benign or (possibly) malicious. Unlike an anti-virus, which performs most of this analysis locally, most EDR agents (the software running on your computer) send that data to a centralised place where it can take an action based on aggregated information (e.g. all laptops of the company).

This is not that different from an observability pipeline (which has been my focus for the last ~3 years before moving to Japan). You basically have an agent on the computers sending telemetry data to a system that should perform an action based on a set of rules. 

The difference is that when we are talking about observability of the services we have built, we control the metrics and logs we expose. We don't need to inject something to collect that information for us. Although you may see people using eBFP for continuous profiling.

If we want to observe the behaviour of the user's computer, we really need a "spyware" able to look at which processes are running and any I/O they are doing. But as you may imagine, an application cannot randomly poke other applications to see what they are doing. Those applications run in what we call User Space.  In User Space, you have a virtual memory (the address the application sees is not the real physical addresses), and to access the hardware, for example, the disk, the application needs to ask the OS for it (which will verify permissions and so on). The OS runs in Kernel Mode, which allows it to have control over hardware and all applications. When an application needs to ask for something, it does a syscall.

As you may have thought by now, we need "two applications", one running in User Mode to send the telemetry data to the cloud and another running in Kernel Mode.  How can we do it? Well, it's going to depend on which OS we are talking about, but for most of them, a common option is to run a Kernel Driver. The problem with kernel drivers is that any bug in them may cause the whole system to crash (remember the number of issues this has caused Microsoft). In Linux, we can [use eBPF for this](https://redcanary.com/blog/threat-detection/ebpf-for-security/). eBPF runs on a virtual machine inside the kernel; the main advantage is that you can run your code in kernel mode without fearing a bug will crash the whole system.

You may know that most companies outside tech use Windows machines. On Windows, you don't have eBPF; you have to write your own kernel driver for that. Although Microsoft is heavily investing in Rust, making it easier to write applications with it thanks to [windows-rs](https://github.com/microsoft/windows-rs) and [windows-drivers-rs](https://github.com/microsoft/windows-drivers-rs), we are far from being able to write Windows kernel drivers with Rust. The solution is to write an agent in Rust, which communicates with a C++ kernel driver using [DeviceIoControl](https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/System/IO/fn.DeviceIoControl.html).

[There is a near future where we can write all those layers in Rust](https://techcommunity.microsoft.com/blog/windowsdriverdev/towards-rust-in-windows-drivers/4449718), but we are not there yet. 
