$TypeDef = @"
using System;
using System.Collections.Generic;

public enum ResolutionMode
{
    Default,
    Overriden,
    Inherited
}

public class ValueResolver<T>
{
    public T Value { get; set; }

    public ResolutionMode ResolutionMode { get; set; }

    public ValueResolver<T> ParentValueResolver { get; set; }

    public ValueResolver()
    {
        this.ParentValueResolver = null;
    }

    public ValueResolver(T defaultValue)
    {
        this.Value = defaultValue;
    }

    public ValueResolver(ValueResolver<T> parentValueResolver)
    {
        this.ParentValueResolver = parentValueResolver;
    }

    public ValueResolver(ValueResolver<T> parentValueResolver, ResolutionMode resolutionMode)
    {
        this.ParentValueResolver = parentValueResolver;
        this.ResolutionMode = resolutionMode;
    }

    public T Get()
    {
        return ResolutionMode switch
        {
            ResolutionMode.Default => ParentValueResolver == null || (Value != null && !EqualityComparer<T>.Default.Equals(Value, default)) ? Value : ParentValueResolver.Get(),
            ResolutionMode.Overriden => Value,
            ResolutionMode.Inherited => ParentValueResolver != null ? ParentValueResolver.Get() : Value,

            _ => throw new ArgumentOutOfRangeException()
        };
    }

    public void Set(T value)
    {
        this.Value = value;
    }

    public static implicit operator T(ValueResolver<T> valueResolver) => valueResolver != null ? valueResolver.Get() : default(T);
    public static implicit operator ValueResolver<T>(T value) => new ValueResolver<T> { Value = value, ResolutionMode = ResolutionMode.Overriden };
}
"@

Add-Type -Language CSharp -TypeDefinition $TypeDef