# Eduonix DevOps E-Degree

This repository contains coursework and project work for the Eduonix DevOps E-Degree:

https://www.eduonix.com/devops-edegree

It is a personal practice repository built while working through the course modules and exam-style tasks. The course covers core DevOps topics such as scripting, Git, Chef, Puppet, Ansible, Vagrant, containers, cloud engineering, and monitoring.

## Repository Purpose

The goal of this repo is to keep all module work in one place, including:

- a simple course landing page
- scripting exercises
- tools-of-the-trade lab work
- supporting configuration files for project submissions

## Current Repository Contents

### Course Landing Page

- [index.html](index.html)

A simple Bootstrap-based project board for the six main course modules.

### Module 2: Scripting Basics

- [projects/scripting-basics/password_generator.rb](projects/scripting-basics/password_generator.rb)

Current scripting project:

- Ruby password generator

What it does:

- generates a random password each time
- includes lowercase letters
- includes uppercase letters
- includes numbers
- includes symbols
- allows repeated generation in a simple CLI loop

Run it with:

```bash
ruby projects/scripting-basics/password_generator.rb
```

### Module 3: Tools of the Trade - Part 1

- [projects/vagrant/Vagrantfile](projects/vagrant/Vagrantfile)

Current Vagrant exercise includes:

- two Ubuntu Vagrant machines
- a shared folder mounted into both machines
- creation of a moderate-size file named `Donotshare`
- a SQLite database named `newdatabage.db`
- four SQLite tables
- a simple Node.js application available through the browser on port 8080

To use it:

```bash
cd projects/vagrant
vagrant up
```

Then open:

```text
http://localhost:8080
```

## Suggested Requirements

Depending on which project you want to run locally, you may need:

- Ruby
- Vagrant
- VirtualBox
- Node.js

## Course Modules

This repository is organized around the six main modules in the Eduonix DevOps E-Degree:

1. DevOps Foundation
2. Scripting Basics
3. Tools of the Trade - Part 1
4. Tools of the Trade - Part 2
5. DevOps Cloud Engineering
6. Monitoring

## Notes

- This is not an official Eduonix repository.
- It is a personal project workspace for course exercises and submissions.
- Some modules are still in progress and will be added over time.