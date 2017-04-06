#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

#import "MyGLView.h"
#import "MyWindow.h"
#import "create_window.h"

static const int width = 800;
static const int height = 600;

static NSOpenGLContext*
createGLContext() {
    NSOpenGLPixelFormatAttribute pixelAttrs[] = {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
        NSOpenGLPFAColorSize, 24,
        NSOpenGLPFAAlphaSize, 8,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFAStencilSize, 8,
        NSOpenGLPFASampleBuffers, 0,
        0,
    };

    NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:pixelAttrs];
    assert(pixelFormat);

    NSOpenGLContext* glContext = [[NSOpenGLContext alloc]
                                  initWithFormat:pixelFormat
                                  shareContext:NULL];
    assert(glContext);

    return glContext;
}

int
main() {
    // From the NSApplication Class Reference:
    //     [...] if you do need to use Cocoa classes within the main()
    //     function itself (other than to load nib files or to instantiate
    //     NSApplication), you should create an autorelease pool before using
    //     the classes and then release the pool when you’re done.
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    // From the NSApplication Class Reference:
    //     The sharedApplication class method initializes the display
    //     environment and connects your program to the window server and the
    //     display server.
    //
    // It also creates the singleton NSApp if it does not yet exist.
    [NSApplication sharedApplication];

    NSOpenGLContext *glContext = createGLContext();
    MyGLView* glView = [[MyGLView alloc]
                        initWithFrame:NSMakeRect(0, 0, width, height)
                        glContext:glContext];
    MyWindow* window = createWindow(glView);

    [glContext makeCurrentContext];
    [glContext setView:glView];
    [glView display];
    [window screen_capture:@"/Users/sankheshjhaveri/Downloads/screen_capture.png"];
    [NSApp run];
    [pool drain];


    return 0;
}  
