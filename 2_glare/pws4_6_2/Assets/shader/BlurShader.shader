Shader "Unlit/BlurShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Radius("Radius",Range(0.00,100.))=5.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #include "UnityCustomRenderTexture.cginc"
			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
			float _Radius;

			fixed4 frag(v2f_customrendertexture i) : SV_Target
			{
				float2 scale = float2(0,_MainTex_TexelSize.y)*_Radius;

                // sample the texture
				fixed4 col = tex2D(_MainTex,i.globalTexcoord);
				float weight = 1.0;
				float w;
				const float S2 = 1.0 / 50.0;
				for (float j = 1.5; j < 10; j+=2.0)
				{
					w = exp(-0.5*j*j*S2);
					col += w * tex2D(_MainTex, i.globalTexcoord + j * scale);
					col += w * tex2D(_MainTex, i.globalTexcoord - j * scale);
					weight += 2.0*w;
				}
				col /= weight;

                return col;
            }
            ENDCG
        }
    }
}
