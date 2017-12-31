module Utils
  def self.collect_arguments
    (0..Vim::evaluate('a:0')).map { |i| Vim::evaluate("a:#{i}") }
  end
  def self.cur_buffer_path
    Vim::evaluate('expand("%:p")')
  end

  def self.escape_string str
    str
      .gsub('\\', '\\\\')
      .gsub('"', '\\"')
  end

  def self.warning_msg msg
      Vim::command("echohl WarningMsg")
      Vim::command("echom \"#{escape_string msg}\"")
  end
  def self.error_msg msg
      Vim::command("echohl ErrorMsg")
      Vim::command("echom \"#{escape_string msg}\"")
  end
end

class SilentDeath < StandardError; end

class Buffer
  public
  attr_accessor :path
  def self.make_new(path = Utils.cur_buffer_path)
    @types.each do |type|
      return type.new(path) if path =~ type::REGEX
    end
    Utils.error_msg "vim-hanami doesn't know what #{path} is supposed to be"
    raise SilentDeath
  end

  def is_spec?
    @m[:type] == 'spec'
  end
  def is_controller?
    false
  end
  def is_view?
    false
  end
  def is_template?
    false
  end

  def spec
    if is_spec?
      return @path
    else
      path = File.dirname @path
      ext = File.extname @path
      base = File.basename @path, ext

      path.gsub!(%r{(.*)/apps/}, '\1/spec/')
      File.join(path, "#{base}_spec#{ext}")
    end
  end
  def impl
    if is_spec?
      path = File.dirname @path
      ext = File.extname @path
      base = File.basename @path, ext

      base.gsub!(%r{(.*)_spec}, '\1')
      path.gsub!(%r{(.*)/spec/}, '\1/apps/')
      File.join(path, "#{base}#{ext}")
    else
      return @path
    end
  end

  def to_controller
    to_X 'controllers', 'rb'
  end
  def to_view
    to_X 'views', 'rb'
  end
  def to_template
    to_X 'templates', 'html.erb'
  end

  protected
  def initialize(path)
    @path = path
    @m = @path.match self.class::REGEX
  end

  private
  def self.inherited(subklass)
    @types ||= []
    @types << subklass
  end
  def to_X x, ext
    File.join(@m[:base], @m[:type], @m[:app], x, @m[:controller], "#{@m[:action]}.#{ext}")
  end
end

class Controller < Buffer
  REGEX = %r{
    (?<base>.+)
    /(?<type>apps|spec)
    /(?<app>[^\\]+)
    /controllers
    /(?<controller>[^\\]+)
    /(?<action>[^\\]+?)\.
  }x

  def is_controller?
    true
  end
end
class View < Buffer
  REGEX = %r{
    (?<base>.+)
    /(?<type>apps|spec)
    /(?<app>[^\\]+)
    /views
    /(?<controller>[^\\]+)
    /(?<action>[^\\]+?)\.
  }x

  def is_view?
    true
  end
end
class Template < Buffer
  REGEX = %r{
    (?<base>.+)
    /(?<type>apps|spec)
    /(?<app>[^\\]+)
    /templates
    /(?<controller>[^\\]+)
    /(?<action>[^\\]+?)\.
  }x

  def is_template?
    true
  end
end

def ex_wrap &block
  yield
rescue SilentDeath
  nil
rescue
  raise
end

def go_to_spec
  ex_wrap do
    cb = Buffer.make_new
    if cb.is_spec?
      Utils.error_msg "Already on spec."
    else
      Vim::command("e #{cb.spec}")
    end
  end
end
def go_from_spec
  ex_wrap do
    cb = Buffer.make_new
    if cb.is_spec?
      Vim::command("e #{cb.impl}")
    else
      Utils.error_msg "Already on implementation."
    end
  end
end
def toggle_spec
  ex_wrap do
    cb = Buffer.make_new
    if cb.is_spec?
      go_from_spec
    else
      go_to_spec
    end
  end
end
def go_to_controller
  ex_wrap do
    cb = Buffer.make_new
    Vim::command("e #{cb.to_controller}")
  end
end
def go_to_view
  ex_wrap do
    cb = Buffer.make_new
    Vim::command("e #{cb.to_view}")
  end
end
def go_to_template
  ex_wrap do
    cb = Buffer.make_new
    cb = Buffer.make_new(cb.impl) if cb.is_spec?
    Vim::command("e #{cb.to_template}")
  end
end
def generate_action
  ex_wrap do
    args = Utils.collect_arguments
    unless args.size.between?(1, 3)
      Utils.error_msg('Too many arguments, see :help HanamiGenerateAction')
      return
    end
    puts args
    raise "TODO"
  end
end
