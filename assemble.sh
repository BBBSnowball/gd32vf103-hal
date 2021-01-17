set -e

cur_path=$(cd `dirname $0`; pwd)
o_file=$cur_path/bin/riscv32imac-unknown-none-elf.o
a_file=$cur_path/bin/riscv32imac-unknown-none-elf.a
src_file=$cur_path/asm.S

if [ -z "$compiler" ] ; then
  for candidate in riscv64-unknown-elf-gcc riscv32-unknown-elf-gcc riscv64-none-elf-gcc riscv32-none-elf-gcc ; do
    if which $candidate &>/dev/null ; then
      compiler=$candidate
      break
    fi
  done
fi

if [ "$compiler" == "" ]; then
    echo "error: Cannot detect any assembly compiler!
You may install riscv32-unknown-elf-gcc with: ./configure --prefix=/opt/riscv32 --with-arch=rv32imac --with-abi=ilp32"
    exit 1
fi

$compiler $src_file -o $o_file -march=rv32imac -mabi=ilp32 -c -g
ar rcs $a_file $o_file
rm $o_file

echo "ASSEMBLY SUCCESS"
