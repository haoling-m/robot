# Python method to return clipboard contents
# Used in menuOptions_valid test cases
def Paste_From_Clipboard():
    from Tkinter import Tk
    import inspect
    return inspect.cleandoc(Tk().clipboard_get().strip())