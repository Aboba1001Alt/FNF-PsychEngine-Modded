package dashadertools; 

import flixel.system.FlxAssets.FlxShader;
import openfl.display3D._internal.GLRenderbuffer; 
import openfl.display3D._internal.GLFramebuffer; 
import openfl.display._internal.ShaderBuffer;
// goddamn prefix 
//this is yoshi engine shader code PLEASE CHECK THIS PERSON OUT!!!! https://github.com/YoshiCrafter29/YoshiEngine 
//most of it is stole from the openfl shader lol
class Flxfixedshaders extends FlxShader {       
	 
    @:noCompletion override function __initGL():Void
    {
        if (__glSourceDirty || __paramBool == null)
        {
            __glSourceDirty = false;
            program = null;

            __inputBitmapData = new Array();
            __paramBool = new Array();
            __paramFloat = new Array();
            __paramInt = new Array();

            __processGLData(glVertexSource, "attribute");
            __processGLData(glVertexSource, "uniform");
            __processGLData(glFragmentSource, "uniform");
        }

        if (__context != null && program == null)
        {
            initGLforce();
        }
    }

    function initGLforce() {
        initGood(glFragmentSource, glVertexSource);
    }
    function initGood(glFragmentSource:String, glVertexSource:String) {
        @:privateAccess
        var gl = __context.gl;
		
		

        #if android
        var prefix = "#version 300 es\n";
        #else
        var prefix = "#version 120\n";
        #end

        #if (js && html5)
        prefix += (precisionHint == FULL ? "precision mediump float;\n" : "precision lowp float;\n");
        #else
        prefix += "#ifdef GL_ES\n"
            + (precisionHint == FULL ? "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
                + "precision highp float;\n"
                + "#else\n"
                + "precision mediump float;\n"
                + "#endif\n" : "precision lowp float;\n")
            + "#endif\n\n";
        #end


        #if android
        prefix += 'out vec4 output_FragColor;\n';
        var vertex = prefix + glVertexSource.replace("attribute", "in").replace("varying", "out").replace("texture2D", "texture").replace("gl_FragColor", "output_FragColor");
        var fragment = prefix + glFragmentSource.replace("varying", "in").replace("texture2D", "texture").replace("gl_FragColor", "output_FragColor");
        #else
       //Add prefix after #version directive if one is present
		var vertex;
		var fragment;
		if(glVertexSource.indexOf('#version')==0)
		{
			var vsFirstNewline = glVertexSource.indexOf('\n');
			vertex = glVertexSource.substr(0, vsFirstNewline)+"\n"+prefix+glVertexSource.substr(vsFirstNewline);
		}
		else
		{
			vertex = prefix + glVertexSource;
		}

		if(glFragmentSource.indexOf('#version')==0)
		{
			var fsFirstNewline = glFragmentSource.indexOf('\n');
			fragment = glFragmentSource.substr(0, fsFirstNewline)+"\n"+prefix+glFragmentSource.substr(fsFirstNewline);
		}
		else
		{
			fragment = prefix + glFragmentSource;
		}
        #end
        
        var id = vertex + fragment;

        @:privateAccess
        if (__context.__programs.exists(id))
        {   
            
		    
            @:privateAccess
            program = __context.__programs.get(id);
            
        }
        else
        {
            
            program = __context.createProgram(GLSL);
            

            // TODO
            // program.uploadSources (vertex, fragment);
            
            @:privateAccess
            program.__glProgram = __createGLProgram(vertex, fragment);
            

            @:privateAccess
             __context.__programs.set(id, program);
        }
		
		#if trace_everything
			/*
			@:privateAccess
			trace(__context);
			@:privateAccess
			trace(__context.__programs);
			@:privateAccess
			trace(program.__glProgram);
			*/
		#end
		
        if (program != null)
        {
            
            @:privateAccess
            glProgram = program.__glProgram;

            
            
            for (input in __inputBitmapData)
            {
                @:privateAccess
                if (input.__isUniform)
                {
                    @:privateAccess
                    input.index = gl.getUniformLocation(glProgram, input.name);
                }
                else
                {
                    @:privateAccess
                    input.index = gl.getAttribLocation(glProgram, input.name);
                }
            }

            
            for (parameter in __paramBool)
            {
                @:privateAccess
                if (parameter.__isUniform)
                {
                    @:privateAccess
                    parameter.index = gl.getUniformLocation(glProgram, parameter.name);
                }
                else
                {
                    @:privateAccess
                    parameter.index = gl.getAttribLocation(glProgram, parameter.name);
                }
            }

            
            for (parameter in __paramFloat)
            {
                @:privateAccess
                if (parameter.__isUniform)
                {
                    @:privateAccess
                    parameter.index = gl.getUniformLocation(glProgram, parameter.name);
                }
                else
                {
                    @:privateAccess
                    parameter.index = gl.getAttribLocation(glProgram, parameter.name);
                }
            }

            
            for (parameter in __paramInt)
            {
                @:privateAccess
                if (parameter.__isUniform)
                {
                    @:privateAccess
                    parameter.index = gl.getUniformLocation(glProgram, parameter.name);
                }
                else
                {
                    @:privateAccess
                    parameter.index = gl.getAttribLocation(glProgram, parameter.name);
                }
            }
        }
    }
}