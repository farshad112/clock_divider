# clock_divider
Clock divider module designed using System Verilog. A simple testbench is developed using SystemVerilog.

# Project Structure
This project uses external dependencies. The project must be configured by running .\configure_ip  script for downloading and setting up the ip dependencies.
This project is organized in following manner,
<br/>
<ui>![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) ring_oscillator <br/>
&nbsp;&nbsp;|   
&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) doc : contains project documents like testcase plan, verification plan etc. <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->&nbsp;&nbsp;<ui>![docxIcon](http://icons.iconarchive.com/icons/treetog/file-type/16/docx-win-icon.png) clock_divider_testcase_plan.txt <br/>
&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) rtl : contains rtl code of clock_divider  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) systemverilog : contains systemverilog code of clock divider <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->![Verilog File](http://icons.iconarchive.com/icons/untergunter/leaf-mimes/16/text-x-generic-icon.png) clock_divider.sv <br/>
&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) scripts : contains scripts for running tests.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->![shell script](http://icons.iconarchive.com/icons/guillendesign/variations-2/16/Script-Console-icon.png) runscript.ps1 : script for ruuning tests with Questasim or modelsim on windows <br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->![shell script](http://icons.iconarchive.com/icons/guillendesign/variations-2/16/Script-Console-icon.png) configure_ip.ps1 : script for downloading external dependencies on windows <br/>  
&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) sim : contains simulation work directory. This is where you should open a terminal to run your tests.<br/>
&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) spec : contains RTL design specification.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->&nbsp;&nbsp;<ui>![docxIcon](http://icons.iconarchive.com/icons/treetog/file-type/16/docx-win-icon.png) dff_design.txt <br/>
&nbsp;&nbsp;|->&nbsp;&nbsp;![FolderIcon](http://icons.iconarchive.com/icons/paomedia/small-n-flat/16/folder-icon.png) tb: Contains Simple SystemVerilog testbench files.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|->&nbsp;&nbsp;![Verilog File](http://icons.iconarchive.com/icons/untergunter/leaf-mimes/16/text-x-generic-icon.png) simple_tb.sv <br/>  

# Project Setup Instruction
```powershell
> cd sim
> ..\scripts\configure_ip -json ..\script\ip_list.json	
```
# Run Instruction
## Running Single Test without coverage analysis
```powershell
> cd sim
> ..\scripts\runscript.ps1  
```
