@[Link(ldflags:
  "-lstdc++ -L#{__DIR__}/../../libnode #{__DIR__}/../../libnode/libnode.so.64"
)]

lib LibNodeJs
  fun init : Void
  fun eval(code : LibC::Char*) : LibC::Char*
  fun deinit : Void
  fun callback() : Void
end
