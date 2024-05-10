(* ::Package:: *)

Print["Reading build settings from ",FileNameJoin[{DirectoryName[$InputFileName],"BuildSettings.m"}]];
Switch[ $OperatingSystem
	
	,"MacOSX", 
	(* Compilation settings for OS X. Assuming Apple Clang compiler is used.*)
	{
		"CompileOptions" -> {
			" -Wall"
			,"-Wextra"
			,"-Wno-unused-parameter"
			,"-gline-tables-only"
			,"-gcolumn-info"
			,"-mmacosx-version-min="<>StringSplit[Import["!sw_vers &2>1","Text"]][[4]]
			,"-std=c++20"
			,"-Ofast"
			,"-fno-math-errno"
			,"-flto"
			,"-pthread"
			,"-march=native","-mtune=native"
		}
		,"LinkerOptions"->{"-lm","-ldl"}
		,"IncludeDirectories" -> {
			DirectoryName[$InputFileName]
		}
		,"LibraryDirectories" -> {}
		(*,"ShellCommandFunction" -> Print*)
		,"ShellOutputFunction" -> (If[#=!="",Print[#]]&)
	},
	"Unix", (* Compilation settings for Linux on x86 architecture. Untested so far. *)
	{
		"CompileOptions" -> {
			" -Wall"
			,"-Wextra"
			,"-std=c++20"
			,"-Wno-unused-parameter"
			,"-Ofast"
			,"-fno-math-errno"
			,"-flto"
			,"-pthread"
			,"-march=native","-mtune=native"
		}
		,"LinkerOptions"->{"-lm","-ldl"}
		,"IncludeDirectories" -> {
			FileNameJoin[{DirectoryName[$InputFileName]}]		
		}
		,"LibraryDirectories" -> {}
		(*,"ShellCommandFunction" -> Print*)
		,"ShellOutputFunction" -> (If[#=!="",Print[#]]&)
	},
	
	"Windows", (* Compilation settings for Windows and Microsoft Visual Studio. Untested so far. *)
	{
		"CompileOptions" -> {"/EHsc", "/wd4244", "/DNOMINMAX", "/arch:AVX","/O2"}
		,"LinkerOptions"->{}
		,"IncludeDirectories" -> {
			FileNameJoin[{DirectoryName[$InputFileName]}]
		}
		,"LibraryDirectories" -> {}
		(*,"ShellCommandFunction" -> Print*)
		,"ShellOutputFunction" -> (If[#=!="",Print[#]]&)
	}
]
