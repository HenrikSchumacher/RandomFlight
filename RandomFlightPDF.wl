(* ::Package:: *)

BeginPackage["RandomFlight`",{"CCompilerDriver`"}];

RandomFlightPDF::usage="RandomFlightPDF[r_?NumericQ,n_Integer] returns the probability density for travelled distance r in an n-step random flight.

RandomFlightPDF[r_?(VectorQ[#,NumericQ]&),n_Integer] returns the same for a list r of distances.";


Begin["`Private`"]

$packageDirectory = DirectoryName[$InputFileName];
$libraryDirectory = FileNameJoin[{$packageDirectory,"LibraryResources",$SystemID}];


RandomFlightPDF[r_?NumericQ,n_Integer]:=cRandomFlightPDF[r,n];

RandomFlightPDF[r_?(VectorQ[#,NumericQ]&),n_Integer]:=cRandomFlightPDFMany[r,n];


Quiet[LibraryFunctionUnload[cRandomFlightPDF]];
ClearAll[cRandomFlightPDF];
cRandomFlightPDF = Module[{name,lib,libname,code,t},
	name = "cRandomFlightPDF";
		
	libname = name;
	
	lib = FileNameJoin[{$libraryDirectory, libname<>CCompilerDriver`CCompilerDriverBase`$PlatformDLLExtension}];
	
	If[Not[FileExistsQ[lib]],
	
		Print["Compiling "<>name<>"..."];

		code=StringJoin["
#include \"WolframLibrary.h\"

#include \"RandomFlightPDF.hpp\"

EXTERN_C DLLEXPORT int "<>name<>"(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res)
{
	mreal x = MArgument_getReal   (Args[0]);
	mint  n = MArgument_getInteger(Args[1]);

	MArgument_setReal(Res, RandomFlight::PDF<mreal>(n)(x) );

	return LIBRARY_NO_ERROR;
}"
		];
	
		t = AbsoluteTiming[
			lib=CreateLibrary[
				code,
				libname,
				"Language"->"C++",
				"TargetDirectory"-> $libraryDirectory,
				(*"ShellCommandFunction"\[Rule]Print,*)
				"ShellOutputFunction"->Print,
				Get[FileNameJoin[{$packageDirectory,"BuildSettings.wl"}]]
			]
		][[1]];
		Print["Compilation done. Time elapsed = ", t, " s.\n"];
	];
	
	LibraryFunctionLoad[lib, name, {Real, Integer}, Real]
];


Quiet[LibraryFunctionUnload[cRandomFlightPDFMany]];
ClearAll[cRandomFlightPDFMany];
cRandomFlightPDFMany = Module[{name,lib,libname,code,t},
	name = "cRandomFlightPDFMany";

	libname = name;
	
	lib = FileNameJoin[{$libraryDirectory, libname<>CCompilerDriver`CCompilerDriverBase`$PlatformDLLExtension}];
	
	If[Not[FileExistsQ[lib]],
	
		Print["Compiling "<>name<>"..."];
	
		code=StringJoin["
#include \"WolframLibrary.h\"

#include \"RandomFlightPDF.hpp\"

EXTERN_C DLLEXPORT int "<>name<>"(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res)
{
	MTensor x_              = MArgument_getMTensor(Args[0]);
	const mint n            = MArgument_getInteger(Args[1]);

	const mint m            = libData->MTensor_getDimensions(x_)[0];

	const mreal * const x   = libData->MTensor_getRealData(x_);

	MTensor y_;

	(void)libData->MTensor_new(MType_Real, 1, &m, &y_);

	mreal * const y = libData->MTensor_getRealData(y_);

	RandomFlight::PDF<mreal> pdf ( n );

	for( mint i = 0; i < m; ++i )
	{
		y[i] = pdf( x[i] );
	}

	MArgument_setMTensor(Res, y_ );

	return LIBRARY_NO_ERROR;
}"
		];
	
		t = AbsoluteTiming[
			lib=CreateLibrary[
				code,
				libname,
				"Language"->"C++",
				"TargetDirectory"-> $libraryDirectory,
				(*"ShellCommandFunction"\[Rule]Print,*)
				"ShellOutputFunction"->Print,
				Get[FileNameJoin[{$packageDirectory,"BuildSettings.wl"}]]
			]
		][[1]];
		Print["Compilation done. Time elapsed = ", t, " s.\n"];
	];
	
	LibraryFunctionLoad[lib, name, {{Real, 1, "Constant"}, Integer}, {Real, 1}]
];


End[];


EndPackage[];
