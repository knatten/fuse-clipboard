using Uno;
using Uno.Compiler.ExportTargetInterop;
using Android.Base.Wrappers;
using Fuse.Scripting;
using Fuse.Resources;
using Uno.Platform;
using Uno.Threading;
using Uno.UX;

[ForeignInclude(Language.Java, "android.content.Context")]
[ForeignInclude(Language.Java, "android.content.ClipboardManager")]
[ForeignInclude(Language.Java, "android.content.ClipData")]
[ForeignInclude(Language.Java, "android.os.Looper")]
[ForeignInclude(Language.Java, "com.fuse.Activity")]
public class Clipboard
{
    [Foreign(Language.Java)]
    public static extern(ANDROID) void SetString(string text)
    @{
        if (Looper.myLooper() == null)
        {
            Looper.prepare();
        }
        Context context = com.fuse.Activity.getRootActivity();
        ClipboardManager clipboard = (ClipboardManager)context.getSystemService(Context.CLIPBOARD_SERVICE);
        ClipData clip = ClipData.newPlainText("app_clipbard", text);
        clipboard.setPrimaryClip(clip);
    @}

    [Foreign(Language.ObjC)]
    public static extern(IOS) void SetString(string text)
    @{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:text];
    @}

    public static extern(!(IOS||ANDROID)) void SetString(string text)
    {

    }
}


[UXGlobalModule]
public class ClipboardManager : NativeModule
{

    static readonly ClipboardManager _instance;

    public ClipboardManager()
    {
        debug_log "ClipM!";
        if (_instance != null) return;
        debug_log "ClipNew!";
        _instance = this;
        Resource.SetGlobalKey(this, "ClipboardManager");
        AddMember(new NativeFunction("setText", (NativeCallback)SetText));
    }

    public object SetText(Context c, object[] args)
    {
        debug_log "Set Text: " + args[0].ToString();
        Clipboard.SetString(args[0].ToString());
        return null;
    }
}
