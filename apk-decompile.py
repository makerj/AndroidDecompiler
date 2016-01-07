"""
ApkDecompiler - The simplest apk decompiler
Copyright (C) 2016  Junhui Lee(ohenwkgdj@gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
"""
import os
import sys
import subprocess
import time
import shutil


def timestr():
    return str(int(time.time()))


def assert_fine(expr, msg):
    if expr != 0:
        print(msg)
        quit()


def print_usage():
    print('Usage: apk-decompile APK-PATH [OUTPUT-PATH]')


def unzip(src, tmp):
    ret = subprocess.call([tools['7zip'], 'x', '-y', '-o' + tmp, src])
    assert_fine(ret, 'error occurred when unzip-ing')
    return absp(tmp + '/classes.dex')


def undex(src, tmp):
    dst = absp(tmp + '/{0}.jar'.format(timestr()))
    ret = subprocess.call([tools['dex2jar'], '-f', '-o', dst, src])
    assert_fine(ret, 'error occurred when undex-ing')
    return absp(dst)


def unjar(src, tmp):
    dst = absp(tmp + '/{0}'.format(basen(argv[1])))
    ret = subprocess.call([tools['jd-cli'], '-od', dst, src])
    assert_fine(ret, 'error occurred when unjar-ing')
    return absp(dst)


absp = os.path.abspath
dirp = os.path.dirname
basen = os.path.basename
argv = sys.argv
if len(argv) <= 1:
    print_usage()
    quit()

src_path = argv[1]
dst_path = argv[2] if len(argv) >= 3 and argv[2] else absp(argv[1] + '-decompiled')
tmp_path = absp(dirp(src_path) + '/.apk-decompile-temp-{0}'.format(timestr()))

root = dirp(absp(argv[0]))
tool_root = absp(root + '/tools')

tools = {
    '7zip': absp(tool_root + '/7z/7-Zip/7z.exe'),
    'dex2jar': absp(tool_root + '/dex2jar-2.0/d2j-dex2jar.bat'),
    'jd-cli': absp(tool_root + '/jd-cli-0.9.1.Final-dist/jd-cli.bat'),
}

if __name__ == '__main__':
    unzipped = unzip(src_path, tmp_path)
    undexed = undex(unzipped, tmp_path)
    unjared = unjar(undexed, tmp_path)
    shutil.move(unjared, dst_path)
    print('removing temporary files...')
    shutil.rmtree(tmp_path)
    print('successfully decompiled at %s' % dst_path)
