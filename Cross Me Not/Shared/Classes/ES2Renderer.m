	//
	//  ES2Renderer.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/18/10.
	//  Copyright Apple Inc 2010. All rights reserved.
	//

#import "ES2Renderer.h"

	// uniform index
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

	// attribute index
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface ES2Renderer (PrivateMethods)
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ES2Renderer

	// Create an OpenGL ES 2.0 context
- (id)init
{
    if (self = [super init])
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
        if (!context || ![EAGLContext setCurrentContext:context] || ![self loadShaders])
        {
            [self release];
            return nil;
        }
		
			// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffers(1, &defaultFramebuffer);
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
    }
	
    return self;
}

- (void)render
{
/*    [EAGLContext setCurrentContext:context];
	
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
	
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
		// SETUP FOR LINES
	GLfloat lineVertices[graph->edgeCount * 4 + graph->edgeCount * 8];
	for (int i=0; i < graph->edgeCount; i++)
	{
		
		lineVertices[i*12] = (graph->vertices[graph->edges[i].vert1].x / (backingWidth/2) ) - 1;
		lineVertices[i*12+1] = -(graph->vertices[graph->edges[i].vert1].y / (backingHeight/2) ) + 1;
		lineVertices[i*12+2] = 0.0;
		lineVertices[i*12+3] = 0.0;
		lineVertices[i*12+4] = 0.0;
		lineVertices[i*12+5] = 1.0;
		
		
		lineVertices[i*12+6] = (graph->vertices[graph->edges[i].vert2].x / (backingWidth/2) ) - 1;
		lineVertices[i*12+7] = -(graph->vertices[graph->edges[i].vert2].y / (backingHeight/2) ) + 1;
		lineVertices[i*12+8] = 0.0;
		lineVertices[i*12+9] = 0.0;
		lineVertices[i*12+10] = 0.0;
		lineVertices[i*12+11] = 1.0;
	}
	
	
		// SETUP FOR VERTICES
	GLfloat points[graph->vertexCount * 6];
	for (int i = 0 ; i < graph->vertexCount; i++) 
	{
		points[i*6] = (graph->vertices[i].x / (backingWidth/2) ) - 1;
		points[i*6+1] = -(graph->vertices[i].y / (backingHeight/2) ) + 1;
		
		points[i*6+2] = 1.0;
		points[i*6+3] = 0.0;
		points[i*6+4] = 0.0;
		points[i*6+5] = 1.0;
		
		if(graph->connectedVertices[i] == 1)
		{
			points[i*6+2] = 0.0;
			points[i*6+4] = 1.0;
		}
	}
		
		// Use shader program
    glUseProgram(program);
		
		// Validate program before drawing. This is a good check, but only really necessary in a debug build.
		// DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    if (![self validateProgram:program])
    {
        NSLog(@"Failed to validate program: %d", program);
        return;
    }
#endif
	
		// Draw
		// RENDERING LINES
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_LINE_SMOOTH);
	glLineWidth(3.0f);
	glVertexPointer(2, GL_FLOAT, 24, lineVertices);
	glColorPointer(4, GL_FLOAT, 24, &lineVertices[2]);
	glDrawArrays(GL_LINES, 0, 2 * graph->edgeCount);
	
		// RENDERING VERTICES
	glEnable(GL_POINT_SMOOTH);
	glPointSize(12.0);
	glVertexPointer(2, GL_FLOAT, 24, points);
	glColorPointer(4, GL_FLOAT, 24, &points[2]);
	glDrawArrays(GL_POINTS, 0, graph->vertexCount);
	
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
*/}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
	
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
	
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
	
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
	
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
	
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
	
    glLinkProgram(prog);
	
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
	
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
	
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
	
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
	
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
	
    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
	
		// Create shader program
    program = glCreateProgram();
	
		// Create and compile vertex shader
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
	
		// Create and compile fragment shader
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
	
		// Attach vertex shader to program
    glAttachShader(program, vertShader);
	
		// Attach fragment shader to program
    glAttachShader(program, fragShader);
	
		// Bind attribute locations
		// this needs to be done prior to linking
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
	
		// Link program
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
		
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
	
		// Get uniform locations
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
	
		// Release vertex and fragment shaders
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
	
    return TRUE;
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
		// Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
	
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
	
    return YES;
}

- (void)dealloc
{
		// Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffers(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }
	
    if (colorRenderbuffer)
    {
        glDeleteRenderbuffers(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
	
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
	
		// Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
    [context release];
    context = nil;
	
    [super dealloc];
}

@end
