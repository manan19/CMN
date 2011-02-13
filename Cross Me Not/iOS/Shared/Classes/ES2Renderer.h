//
//  ES2Renderer.h
//  Cross Me Not
//
//  Created by Manan Patel on 2/18/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "ESRenderer.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface ES2Renderer : ESRenderer
{
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;

    GLuint program;
}

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end

