module.exports =
  # 当前校验的元素，默认没有，在 `validate()` 方法中传入
  # $item: {}

  # 邮箱：宽泛的正则校验
  email: (text) ->
    /^(?:[a-z0-9]+[_\-+.]+)*[a-z0-9]+@(?:([a-z0-9]+-?)*[a-z0-9]+.)+([a-z]{2,})+$/i.test(text)

  # 仅支持 8 种类型的 day
  # 20120409 | 2012-04-09 | 2012/04/09 | 2012.04.09 | 以上各种无 0 的状况
  date: (text) ->
    reg = /^([1-2]\d{3})([-\/.])?(1[0-2]|0?[1-9])([-\/.])?([1-2]\d|3[01]|0?[1-9])$/

    false if (!reg.test(text))

    taste = reg.exec(text)
    year = +taste[1]
    month = +taste[3] - 1
    day = +taste[5]
    d = new Date(year, month, day)

    year is d.getFullYear() and month is d.getMonth() and day is d.getDate()

  # 手机：仅中国手机适应；以 1 开头，第二位是 3,4,5,7,8,9，并且总位数为 11 位数字
  mobile: (text) ->
    /^1[3|4|5|7|8|9]\d{9}$/.test(text)

  # 座机：仅中国座机支持；区号可有 3、4位数并且以 0 开头；电话号不以 0 开头，最 8 位数，最少 7 位数
  # 但 400/800 除头开外，适应电话，电话本身是 7 位数
  # 0755-29819991 | 0755 29819991 | 400-6927972 | 4006927927 | 800...
  tel: (text) ->
    /^(?:(?:0\d{2,3}[- ]?[1-9]\d{6,7})|(?:[48]00[- ]?[1-9]\d{6}))$/.test(text)

  number: (text) ->
    min = +@$item.attr('min')
    max = +@$item.attr('max')
    result = /^\-?(?:[1-9]\d*|0)(?:[.]\d+)?$/.test(text)
    text = +text
    step = +@$item.attr('step')

    # ignore invalid range silently
    isNaN(min) and (min = text - 1)
    isNaN(max) and (max = text + 1)

    # 目前的实现 step 不能小于 0
    result and ( if isNaN(step) or 0 >= step then text >= min and text <= max else 0 is (text + min) % step and (text >= min and text <= max))

  # 判断是否在 min / max 之间
  range: (text) ->
    @number(text)

  # 支持类型:
  # http(s)://(username:password@)(www.)domain.(com/co.uk)(/...)
  # (s)ftp://(username:password@)domain.com/...
  # git://(username:password@)domain.com/...
  # irc(6/s)://host:port/... 需要测试
  # afp over TCP/IP: afp://[<user>@]<host>[:<port>][/[<path>]]
  # telnet://<user>:<password>@<host>[:<port>/]
  # smb://[<user>@]<host>[:<port>][/[<path>]][?<param1>=<value1>[;<param2>=<value2>]]
  url: (text) ->
    protocols = '((https?|s?ftp|irc[6s]?|git|afp|telnet|smb):\\/\\/)?'
    userInfo = '([a-z0-9]\\w*(\\:[\\S]+)?\\@)?'
    domain = '(?:[a-z0-9]+(?:\-[\w]+)*\.)*[a-z]{2,}'
    port = '(:\\d{1,5})?'
    ip = '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}'
    address = '(\\/\\S*)?'
    domainType = [protocols, userInfo, domain, port, address]
    ipType = [protocols, userInfo, ip, port, address]
    validate

    validate = (type) ->
      new RegExp('^' + type.join('') + '$', 'i').test(text)

    validate(domainType) or validate(ipType)

  # 密码项目前只是不为空就 ok，可以自定义
  password: (text) ->
    @text(text)

  checkbox: ->
    patterns._checker('checkbox')

  # radio 根据当前 radio 的 name 属性获取元素，只要 name 相同的这几个元素中有一个 checked，则验证难过
  radio: (checkbox) ->
    patterns._checker('radio')

  _checker: (type) ->
    # TODO: a better way?!
    form = @$item.parents('form').eq(0)
    identifier = 'input:' + type + '[name="' + @$item.attr('name') + '"]'
    result = false
    $items = $(identifier, form)

    # TODO: a faster way?!
    @$item.each (i, item) ->
      result = true if item.checked and !result

    result

  # text[notEmpty] 表单项不为空
  # [type=text] 也会进这项
  text: (text) ->
    max = parseInt(@$item.attr('maxlength'), 10)

    notEmpty = (text) ->
      !!text.length and !/^\s+$/.test(text)

    if isNaN(max) then notEmpty(text) else notEmpty(text) and text.length <= max
