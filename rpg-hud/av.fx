texture picture;
texture circleMask;

technique transform
{
        pass P0
	{

	Texture[0] = picture;
        AddressU[0] = Clamp;
        AddressV[0] = Clamp;
        ColorOp[0] = Modulate;
        ColorArg1[0] = Texture;
        ColorArg2[0] = Diffuse;
        AlphaOp[0] = Modulate;
        AlphaArg1[0] = Texture;
        AlphaArg2[0] = Diffuse;
     
        Texture[1] = circleMask;
        TexCoordIndex[1] = 0;
        AddressU[1] = Clamp;
        AddressV[1] = Clamp;
        ColorOp[1] = SelectArg1;
        ColorArg1[1] = Current;
        AlphaOp[1] = Modulate;
        AlphaArg1[1] = Current;
        AlphaArg2[1] = Texture;

        ColorOp[2] = Disable;
        AlphaOp[2] = Disable;

	}
}