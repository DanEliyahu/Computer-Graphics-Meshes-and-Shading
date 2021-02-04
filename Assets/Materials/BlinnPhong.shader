Shader "CG/BlinnPhong"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (0.14, 0.43, 0.84, 1)
        _SpecularColor ("Specular Color", Color) = (0.7, 0.7, 0.7, 1)
        _AmbientColor ("Ambient Color", Color) = (0.05, 0.13, 0.25, 1)
        _Shininess ("Shininess", Range(0.1, 50)) = 10
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // From UnityCG
            uniform fixed4 _LightColor0;

            // Declare used properties
            uniform fixed4 _DiffuseColor;
            uniform fixed4 _SpecularColor;
            uniform fixed4 _AmbientColor;
            uniform float _Shininess;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float3 worldPosition : POSTION;
                float3 normal : NORMAL;
                float4 pos : SV_POSITION;
            };


            v2f vert(appdata input)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.worldPosition = mul(unity_ObjectToWorld, input.vertex);
                output.normal = normalize(mul(unity_ObjectToWorld, float4(input.normal, 0.0)).xyz);;
                return output;
            }


            fixed4 frag(v2f input) : SV_Target
            {
                float3 n = normalize(input.normal);
                float3 l = normalize(_WorldSpaceLightPos0.xyz);
                float3 v = normalize(_WorldSpaceCameraPos - input.worldPosition);
                float3 h = normalize((l + v) / 2);
                fixed4 _colord = max(dot(l, n), 0) * _DiffuseColor * _LightColor0;
                fixed4 _colora = _AmbientColor * _LightColor0;
                fixed4 _colors = pow(max(dot(n, h), 0), _Shininess) * _SpecularColor * _LightColor0;
                return _colord + _colora + _colors;
            }
            ENDCG
        }
    }
}