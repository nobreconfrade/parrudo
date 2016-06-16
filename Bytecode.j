.class public Bytecode
.super java/lang/Object

.method public <init>()V
	aload_0

	invokenonvirtual java/lang/Object/<init>()V
	return
.end method

.method public static main([Ljava/lang/String;)V
	.limit stack  10
	.limit locals 10
	ldc 130
	istore 1
	bipush 20
	istore 2
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 1
	iload 2
	iadd
	invokevirtual java/io/PrintStream/println(I)V
	return
.end method
