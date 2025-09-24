# 🧽 sponge Cheat Sheet (Arch Linux / moreutils)

`sponge` reads all input before writing output, letting you safely
overwrite files that are also being read in the same pipeline.

---

## 📌 15 Common One-Liners

### 1. Remove lines containing a word
```bash
grep -v TODO notes.md | sponge notes.md
```

### 2. Sort a file in place
```bash
sort shopping_list.txt | sponge shopping_list.txt
```

### 3. Deduplicate file entries
```bash
sort -u ~/.ssh/known_hosts | sponge ~/.ssh/known_hosts
```

### 4. Append processed output
```bash
echo "export PATH=\$PATH:/new/bin" | sponge -a ~/.bashrc
```

### 5. Strip blank lines
```bash
grep -v '^[[:space:]]*$' config.txt | sponge config.txt
```

### 6. Change file extensions in a list
```bash
sed -E 's/\.jpeg$/.jpg/' filelist.txt | sponge filelist.txt
```

### 7. Remove comments from config
```bash
awk '!/^#/' ~/.config/app.conf | sponge ~/.config/app.conf
```

### 8. Edit root-owned files safely
```bash
grep -v root /etc/hosts | sudo sponge /etc/hosts
```

### 9. Keep only errors in a log
```bash
grep -i error /var/log/app.log | sponge /var/log/app.log
```

### 10. Normalize whitespace
```bash
tr -s ' ' < messy.txt | sponge messy.txt
```

### 11. Convert tabs to spaces in place
```bash
expand file.txt | sponge file.txt
```

### 12. Collapse multiple newlines
```bash
cat file.txt | awk 'NF {print} !NF && !blank {print ""; blank=1} NF {blank=0}' | sponge file.txt
```

### 13. Sort + dedupe + count
```bash
cat urls.txt | sort -u | tee >(wc -l >&2) | sponge urls.txt
```

### 14. Remove trailing spaces
```bash
sed 's/[[:space:]]*$//' file.txt | sponge file.txt
```

### 15. Keep only unique lines (no sort)
```bash
awk '!seen[$0]++' file.txt | sponge file.txt
```

---

⚡ **Tip:**  
Use `sponge` anytime you’d normally do:
```bash
cmd file > file.tmp && mv file.tmp file
```
