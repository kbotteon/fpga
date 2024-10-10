#!/usr/bin/env python3
"""
xsim.py

Run xsim for a given module, assuming the required configuration files
are present in its folder tree.
"""

import os
import subprocess
import sys
import argparse
import re
import pathlib

################################################################################

WORK_DIR = ".xsim"
ROOT_DIR = os.getcwd()

################################################################################

def shell(command, logpath, cwd) -> None:
    """
    Run a shell command, logging to both the terminal and logpath
    """
    with open(logpath, "a") as log_obj:

        result = subprocess.run(command, shell=True, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, text=True, cwd=cwd)

        sys.stdout.write(result.stdout)
        log_obj.write(result.stdout)

        if result.returncode != 0:
            raise subprocess.CalledProcessError(result.returncode, command)

################################################################################

def ap_validate_path(path: str) -> str:

    full_path = pathlib(path).resolve()

    if not os.path.isdir(full_path):
        raise NotADirectoryError(f"Module path {full_path} does not exist")

    return full_path

################################################################################

def create_parser() -> argparse.ArgumentParser:

    ap = argparse.ArgumentParser(
        prog="xsim.py",
        description="Manages xsim runs"
    )

    ap.add_argument(
        "-m",
        "--modname",
        type=str,
        required=True,
        help="The module path"
    )

    return ap

################################################################################

def main(args) -> None:

    MODULE_PATH = pathlib.Path(args.modname).resolve()
    WORK_PATH = f"{MODULE_PATH}/{WORK_DIR}"

    # Set up workspace and cd to it
    os.makedirs(WORK_PATH, exist_ok=True)
    os.chdir(WORK_PATH)

    LOG_PATH = f"{WORK_PATH}/xsim.log"

    xvlog_cmd = f"xvlog --incr --relax -L uvm -prj {MODULE_PATH}/xsim.prj"
    shell(xvlog_cmd, LOG_PATH, WORK_PATH)

    xelab_cmd = f"xelab --incre --debug typical --relax --mt 8 -L work -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_behav work.tb work.glbl"
    shell(xelab_cmd, LOG_PATH, WORK_PATH)

    xsim_cmd = f"xsim tb_behav -key {{Behavioral:sim_1:Functional:tb}} -tclbatch {MODULE_PATH}/xsim.tcl"
    shell(xsim_cmd, LOG_PATH, WORK_PATH)

################################################################################

if __name__ == "__main__":

    ap = create_parser()
    args = ap.parse_args()

    main(args)

    os.chdir(ROOT_DIR)
