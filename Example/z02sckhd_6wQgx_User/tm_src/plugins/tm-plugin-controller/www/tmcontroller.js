cordova.define("tm-plugin-controller.TMController", function(require, exports, module) {
               var exec = require('cordova/exec');
               var cordova = require('cordova');
               
               function TMController(){
               
               }
               /**
                * 以present  方式弹出一个新的窗口,
                * success   成功回调
                * error   失败回调
                * animate   是否需要动画 true/false
                * url   是否需要动画 true/false
                * folder   html路径 如："pages"
                */
               TMController.prototype.presentCtr = function(success, error, animate, url, folder){
               exec(success, error, "TMController", "presentCtr", [animate,url,folder]);
               };
               
               /**
                * 以dismiss  方式返回,
                * success   成功回调
                * error   失败回调
                * animate   是否需要动画 true/false
                */
               TMController.prototype.dismissCtr = function(success, error, animate){
               exec(success, error, "TMController", "dismissCtr", [animate]);
               };
               
               /**
                * 以push  方式弹出一个新的窗口,若没有导航控制器实则是present出窗口
                * success   成功回调
                * error   失败回调
                * animate   是否需要动画 true/false
                * url   是否需要动画 true/false
                * folder   html路径 如："pages"
                */
               TMController.prototype.pushCtr = function(success, error, animate, url, folder){
               exec(success, error, "TMController", "pushCtr", [animate, url, folder]);
               };
               
               /**
                * 以pop  方式返回,
                * success   成功回调
                * error   失败回调
                * animate   是否需要动画 true/false
                */
               TMController.prototype.popCtr = function(success, error, animate){
               exec(success, error, "TMController", "popCtr", [animate]);
               };
               
               /**
                * 以present  方式弹出一个原生ViewController
                * success   成功回调
                * error   失败回调
                * animate   是否需要动画 true/false
                * className   要弹出的原生ViewController类名
                * paramStr   要传递给此ViewController的参数
                */
               TMController.prototype.presentToNative = function(success, error, animate, className, paramStr){
               exec(success, error, "TMController", "presentToNative", [animate, className, paramStr]);
               };
               
               /**
                * 以push  方式弹出一个原生ViewController,若没有navigationcontroller，则会创建一个并present出此ViewController
                * success   成功回调
                * error   失败回调
                * animate   是否需要动画 true/false
                * className   要弹出的原生ViewController类名
                * paramStr   要传递给此ViewController的参数
                */
               TMController.prototype.pushToNative = function(success, error, animate, className, paramStr){
               exec(success, error, "TMController", "pushToNative", [animate, className, paramStr]);
               };
               
               /**
                * 根据原生的ViewController名发送消息
                * success   成功回调
                * error   失败回调
                * message   消息内容,标准json字符串
                * className   消息接收的ViewController类名
                * from   发送者，字符串，可自定义
                */
               TMController.prototype.sendMessage = function(success, error, message, className, from){
               exec(success, error, "TMController", "sendMessage", [message, className, from]);
               };
               
               module.exports = new TMController();
});
