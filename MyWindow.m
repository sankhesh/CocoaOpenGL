// Copyright 2012 Chad Versace <chad@chad-versace.us>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MyWindow.h"
#import <OpenGL/gl.h>

static const int kEscapeKey = 53;

@implementation MyWindow

    - (void) close {
        [NSApp terminate:self];

        // If the app refused to terminate, this window should still close.
        [super close];
    }

    - (BOOL) acceptsFirstResponder {
        return YES;
    }

    - (void) keyDown:(NSEvent*)event {
        if ([event keyCode] == kEscapeKey) {
            [self close];
        }
        else {
            [super keyDown:event];
        }
    }

    - (void) screen_capture:(NSString*)file_name {
        // Get the size of the image in a retina safe way
        NSRect backRect = [self convertRectToBacking: [self frame]];
    int W = NSWidth(backRect);
    int H = NSHeight(backRect);

  // Create image. Note no alpha channel. I don't copy that.
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
        pixelsWide: W pixelsHigh: H bitsPerSample: 8 samplesPerPixel: 3 hasAlpha: NO
        isPlanar: NO colorSpaceName: NSCalibratedRGBColorSpace bytesPerRow: 3*W bitsPerPixel: 0];
  
  // The following block does the actual reading of the image
    glPushAttrib(GL_PIXEL_MODE_BIT); // Save state about reading buffers
    glReadBuffer(GL_FRONT);
    glPixelStorei(GL_PACK_ALIGNMENT, 1); // Dense packing
    glReadPixels(0, 0, W, H, GL_RGB, GL_UNSIGNED_BYTE, [rep bitmapData]);
    glPopAttrib();
    CIImage* ciimag = [[CIImage alloc] initWithBitmapImageRep: rep];
    CGAffineTransform trans = CGAffineTransformIdentity;
    trans = CGAffineTransformMakeTranslation(0.0f, H);
    trans = CGAffineTransformScale(trans, 1.0, -1.0);
    ciimag = [ciimag imageByApplyingTransform:trans];
    rep = [[NSBitmapImageRep alloc] initWithCIImage: ciimag];
    if ([file_name length] < 1) { //save to clipboard
        NSImage *imag = [[[NSImage alloc] init] autorelease];
        [imag addRepresentation:rep];
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        NSArray *copiedObjects = [NSArray arrayWithObject:imag];
        [pasteboard writeObjects:copiedObjects];
        return;
    }
    NSData *data = [rep representationUsingType: NSPNGFileType properties: nil];
    [data writeToFile: file_name atomically: NO];
    }
@end
