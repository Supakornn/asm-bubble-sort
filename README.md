# 🛠️ Bubble Sort Assembly Program

## 🚀 How to Run

### Requirements:

- [MASM32 SDK](https://www.masm32.com/)
- [Visual Studio Developer Command Prompt](https://docs.microsoft.com/en-us/dotnet/framework/tools/developer-command-prompt-for-vs)

### Steps:

1. **📄 Prepare the Input File:**

   - Edit the `input.txt` file to contain the array you want to sort, with each element separated by a space.
     ```txt
     5 2 3 1 4
     ```

2. **🔧 Assemble the Code:**

   - Open the Developer Command Prompt for Visual Studio.
   - Navigate to the directory containing your assembly file (`main.asm`).
   - Assemble the code:
     ```sh
     ml /c /coff main.asm
     ```

3. **🔗 Link the Object File:**

   - Link the object file to create an executable:
     ```sh
     link /subsystem:console main.obj
     ```

4. **▶️ Run the Executable:**

   - Run the executable to perform the bubble sort:
     ```sh
     main.exe
     ```

5. **📊 Check the Output:**
   - The sorted array will be displayed in the console.
