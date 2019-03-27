function input = GetNumEdit( hObject )
input = str2num(hObject.String);
if (isempty(input))
     hObject.String='0';
else
    hObject.Value=input;
end

