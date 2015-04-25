require 'Qt'


app = Qt::Application.new(ARGV)
hello = Qt::PushButton.new("Hello world!", nil)
hello.resize(300, 50)
hello.show

app.exec
