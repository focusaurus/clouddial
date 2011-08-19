#!/usr/bin/python
"""This is a DIY python script sort of like a Makefile minus the insanity.

Any function below prefixed by the @command decorator can be run on the command
line like this:

./task.py upload
"""
import os
import shlex
import shutil
import subprocess
import sys
import tempfile
import types

EC_SUCCESS = 0
EC_UNKNOWN_COMMAND = 11
commands = {}

#This is a decorator to build up our map of command names to functions
def command(function):
    commands[function.__name__.lower()] = function
    return function

def parseCommand(command):
    if type(command) in types.StringTypes:
        return shlex.split(command)
    else:
        return command

def run(command):
    try:
        subprocess.check_call(parseCommand(command))
    except subprocess.CalledProcessError, info:
        sys.exit(info.returncode)

def runShellScript(script, sudo=False):
    outFile = tempfile.NamedTemporaryFile(mode='w', prefix='taskScript',
        delete=False)
    outFile.write(script)
    outFile.close()
    sudoOpts = ""
    if sudo:
        sudoOpts = "sudo"
    run("%s /bin/sh '%s'" % (sudoOpts, outFile.name))
    os.remove(outFile.name)

def background(command):
    subprocess.Popen(parseCommand(command))

@command
def upload():
    run("knife cookbook upload clouddial")

@command
def realCreds():
    shutil.copy(".chef/knife.rb.REAL", ".chef/knife.rb")

@command
def sampleCreds():
    shutil.copy(".chef/knife.rb.SAMPLE", ".chef/knife.rb")

def main(args):
    if len(args) < 2:
        allValid = commands.keys()
        allValid.sort()
        for name in allValid:
            print name
        return EC_SUCCESS
    command = (args[1] or "").lower()
    args = args[2:]
    if command in commands:
        commands.get(command)(*args)
    else:
        message = "Unknown command: %s" % command
        sys.stderr.write(message + "\n")
        return EC_UNKNOWN_COMMAND

if __name__ == "__main__":
    sys.exit(main(sys.argv))
