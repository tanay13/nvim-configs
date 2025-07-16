## Why use nvim-jdtls instead of using it through mason-lspconfig

- It was not setting the classpath and workspace dir properly on opening a java file due to which the `go to definition` functionality was not working well for standard classes.
- using `nvim-jdtls` along with `autocmd` allows to run the config everytime a java file with given root_dir is opened.
- `autocmd` acts as a even listener which performs certain task when a certain type of event is triggered, in this case opening of a java file.


## 🧩 Why Setting Up LSP for Java Is More Complicated than for C/C++

Here are **5 key reasons** why configuring the LSP for Java (`jdtls`) is more complex than for languages like C/C++ (`clangd`):

---

### 1. 🧠 Per-Project Workspace Requirement

- `jdtls` requires a **unique workspace directory** (`-data`) per project to store metadata like indexes and preferences.
- Other LSPs like `clangd` do **not** require this — they attach to the project root directly.

---

### 2. ⚙️ Build Tool & Classpath Complexity

- Java heavily depends on **classpath resolution** to locate dependencies and standard libraries.
- Without `pom.xml`, `build.gradle`, or `.classpath`, Java LSP cannot resolve symbols.
- In contrast, C/C++ typically only needs a `compile_commands.json` file, which is optional for basic features.

---

### 3. 🏗 Eclipse-Based Server with Many Moving Parts

- `jdtls` is based on the **Eclipse language server**, which requires:
  - A specific `launcher.jar` file
  - A platform-specific `config_<os>` directory
  - Java-specific flags and environment setup
- Other LSPs like `clangd` are just single binary executables — simpler and self-contained.

---

### 4. 🔁 Cannot Use `lspconfig.setup()` Directly

- `jdtls` must be launched using `require("jdtls").start_or_attach({ ... })` at runtime per project.
- It **cannot** be declared statically with `lspconfig.jdtls.setup()` like other LSPs.
- This adds conditional logic and often involves `autocmd` or `ftplugin`.

---

### 5. 📦 Standard Library Isn’t Auto-Resolved

- Java LSP needs proper detection of the JDK to resolve even core classes like `String` or `List`.
- Without JDK setup and classpath, you lose go-to-definition and autocomplete for standard Java classes.
- In C++, standard libraries are usually discovered automatically via the system compiler.

---


