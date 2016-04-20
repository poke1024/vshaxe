// quick and dirty externs for VS Code API
import haxe.extern.EitherType;
import js.node.ChildProcess.ChildProcessForkOptions;
import js.Promise;

@:jsRequire("vscode")
extern class Vscode {
    static var commands(default,never):VscodeCommands;
    static var window(default,never):VscodeWindow;
    static var workspace(default,never):VscodeWorkspace;
}

extern class VscodeCommands {
    function registerCommand(command:String, callback:Void->Void):Disposable;
}

typedef QuickPickItem = {
    @:optional var description : String;
    @:optional var detail:Null<String>;
    var label:String;
}

typedef QuickPickOptions = {
    @:optional var matchOnDescription:Bool;
    @:optional var matchOnDetail:Bool;
    @:optional var placeHolder:String;
}

typedef InputBoxOptions = {
    @:optional var password:Bool;
    @:optional var placeHolder:String;
    @:optional var prompt:String;
    @:optional var validateInput:String -> String;
    @:optional var value:String;
}

extern class VscodeWindow {
    function showInformationMessage(message:String, items:haxe.extern.Rest<String>):Thenable<String>;
    function showErrorMessage(message:String, items:haxe.extern.Rest<String>):Thenable<String>;
    function setStatusBarMessage(text:String, ?hideAfterTimeout:Int):Disposable;
    function createOutputChannel(name:String):OutputChannel;
    function showQuickPick<T:QuickPickItem>(items:Array<T>, ?options:QuickPickOptions):Promise<T>;
    function showInputBox(options:InputBoxOptions):Thenable<String>;
}

extern class VscodeWorkspace {
    var rootPath(default,never):String;
}

extern class OutputChannel {
    function append(value:String):Void;
    function appendLine(value:String):Void;
}

@:enum abstract TransportKind(Int) {
    var stdio = 0;
    var ipc = 1;
}

typedef NodeModule = {
    var module:String;
    @:optional var transport:TransportKind;
    @:optional var args:Array<String>;
    @:optional var options:ChildProcessForkOptions;
}

typedef ServerOptions = {
    run: NodeModule,
    debug: NodeModule,
}

typedef LanguageClientOptions = {
    @:optional var documentSelector:EitherType<String,Array<String>>;
    @:optional var synchronize:SynchronizeOptions;
    @:optional var diagnosticCollectionName:String;
    @:optional var initializationOptions:Dynamic;
}

typedef SynchronizeOptions = {
    @:optional var configurationSection:EitherType<String,Array<String>>;
    @:optional var fileEvents:EitherType<FileSystemWatcher,Array<FileSystemWatcher>>;
    @:optional var textDocumentFilter:TextDocument->Bool;
}

@:jsRequire("vscode-languageclient", "LanguageClient")
extern class LanguageClient {
    function new(name:String, serverOptions:ServerOptions, languageOptions:LanguageClientOptions, ?forceDebug:Bool);
    function start():Disposable;
    function stop():Void;
    function onNotification(type:{method:String}, handler:Dynamic->Void):Void;
    function onReady():Promise<Void>;
}

typedef Disposable = {
    function dispose():Void;
}

extern class ExtensionContext {
    function asAbsolutePath(path:String):String;
    var subscriptions:Array<Disposable>;
}

extern class TextDocument {}
extern class FileSystemWatcher {}