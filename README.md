# fbcunn-aws-patcher
Patches the [fbcunn library](https://github.com/facebook/fbcunn) to work on AWS EC2 g2.8xlarge instances (and similar hardware).

The problem is that fbcunn assumes GPUs with 3.5+ compute capability, but 
the EC2 GPUs only have compute capability (CC) 3.0. [This library](https://github.com/bryancatanzaro/generics)
provides CC-3.0-compatible implementations of the problematic `__ldg()` and `__shfl()` intrinsics, 
so patching fbcunn to work on CC 3.0 GPUs is just a matter of including those headers in the 
right places, and recompiling against the older architecture.

## Installation
1.  Install the [generics library](https://github.com/bryancatanzaro/generics)

  ```
  git clone git@github.com:bryancatanzaro/generics.git
  sudo cp -r generics/generics /usr/local/cuda/include/
  ```
  
2.  Patch fbcunn

  ```
  ./patch.sh /path/to/fbcunn
  ```
  
3. Rebuild fbcunn (go get a coffee)

  ``` 
  cd /path/to/fbcunn && luarocks make rocks/fbcunn-scm-1.rockspec
  ```

4.  Test it

  ```
  th hsm_test.lua
  ```

These instructions assume you've already tried to install fbcunn. If you're patching a fresh clone, you'll need to grab the cuda submodule in the fbcunn directory before trying to patch: `git submodule init && git submodule update`.
