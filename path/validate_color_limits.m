function validate_color_limits(value)
    if isempty(value), return; end
    validateattributes(value,{'numeric'},{'vector','numel',2,'finite'});
    assert(value(2)>value(1),'Limites de cor invalidos.');
end
