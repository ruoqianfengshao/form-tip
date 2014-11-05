# form-tip

Just want to tip for elements such as input, textarea, table, button or some else which may will use `data-*` to transform data

## What is it
  form-tip base on [validate.js](https://github.com/sofish/validator.js), and try to extend it with html5 data-*.
  > Demo for [form-tip](http://ruoqianfengshao.github.io/form-tip/)

## How to use
### 1. link

```html
<link rel="stylesheet" href="https://rawgit.com/ruoqianfengshao/form-tip/master/public/form-tip.css">
<script src="https://rawgit.com/ruoqianfengshao/form-tip/master/public/form-tip.js"></script>
<script>formTip = require("form_tip")</script>
```

### 2. 实例化
`$("#form").validateTip();`

`$("#form").validateTip(options);`

validateTip 方法支持一个 options 对象作为参数。当不传参数时，options 具备默认值。完整的对象如下描述：
```
options = {
  // 需要校验的表单项，（默认是 `[required]`），支持任何 jQuery 选择器可以选择的标识
  identifie: {String},

  // tip 的方向， 默认是 left， 可以在 identifie 上指定 data-direct
  direct: {'left' or 'up'},

  // 触发 tip 消失的动作，默认是 time（时间触发），可以是其他 event, 如 focusin
  disapper: '{Event} || time',

  // tip 显示的时间，毫秒级，默认是 0（不自动消失），可以在 identifie 上指定 data-interval
  interval:  {Integer},

  // tip 的提示方式，'all' 代表一起提示，'one' 代表提示第一个, 默认是 'all'
  scope: {'all' or 'one'},

  // tip 的提示样式是否带图标，true 代表带有图标，false 代表不带图标, 默认是 false
  icon: {true or false},

  // 出错时的 callback，第一个参数是所有出错表单项集合
  errorCallback(unvalidFields): {Function},

  before: {Function}, // 表单检验之前
  after: {Function},  // 表单校验之后，只有 __return true__ 才会提交表单
}
```
### 3. 校验
通过 `data-type` 、 `type` ，对表单元素及 button 等其他非表单元素进行校验，校验被指定元素上的 `data-value` 或 `value` 以及 `[contenteditable].text()`
目前支持的 type 和 validate.js 保持一致，后续根据项目需要加入其他类型的校验。

### 4. 特殊参数
支持在被校验元素上指定 tip 的参数：
 1. 提示方向 `data-direct`

 ```html
 <input type="text" data-direct="up" required>
 ```

 2. 提示存在时间 `data-interval`

 ```html
 <input type="text" data-interval="5000" required>
 ```

 3. 为空时提示 `data-empty-message`

 ```html
 <input type="text" data-empty-message="用户名称必填，由6-16位下划线、数字英文字母组成" name="name" required>
 ```

 4. 不正确时提示 `data-unvalid-message`

 ```html
 <input type="text" data-unvalid-message="请正确填写用户名称，由6-16位下划线、数字英文字母组成" name="name" required>
 ```

默认提示：
 1. 为空时提示 “请填写此项”
 2. 不正确时提示 “请正确填写”

### 5. 表单提交
```javascript
$("#form").validateTip();
$("#form").on("submit", function(evt){
  evt.preventDefault();
  // submit action;
})
```
### 6. 许可协议
基于 MIT 协议授权，你可以使用于任何地方（包括商业应用）、修改并重新发布。详见：[LICENSE](https://github.com/ruoqianfengshao/form-tip/blob/gh-pages/LICENSE)
