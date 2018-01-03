# SpringBoard-S44-memtest

A LUA memory consumption benchmark to compare master (104 tag) and develop
branches of spring.

Just clone the repository and run the `run.sh` script. It would take some time,
be patient...

After running 2 instances of the engine, you should have the log files,
with the LUA consumed memory inside, in the `results` folder. Such files are
meant to be read in the terminal. Just execute the following commands:

```
cat results/master.log
cat results/develop.log
```
