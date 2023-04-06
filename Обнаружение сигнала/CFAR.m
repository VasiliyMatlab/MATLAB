function Border = CFAR(S,a,b,c)
%�������, �������������� ������������ ������ �� ������ CFAR-���������
% S - ������� ������ ������ (������ �������)
% a - ������ ���� ����������, ������
% b - ������ ���� ��������� (������� ����), ������
% c - �������� ������, ����
% Border - �������� ������ ������ (������� �����)

Border = zeros(1,length(S));
for i = 1:length(S)
    if i<=(a+b)
        if i<=(b+1)
            Border(i) = sum(S(i+b+1:i+a+b));
        else
            Border(i) = sum(S(1:i-b-1))+sum(S(i+b+1:i+a+b));
        end
    elseif i>(length(S)-(a+b))
        if i>=(length(S)-b)
            Border(i) = sum(S(i-a-b:i-b-1));
        else
            Border(i) = sum(S(i-a-b:i-b-1))+sum(S(i+b+1:end));
        end
    else
        Border(i) = sum(S(i-a-b:i-b-1)+S(i+b+1:i+a+b));
    end
end
Border = c*Border;

end