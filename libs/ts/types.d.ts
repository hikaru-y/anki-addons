declare global {
    function bridgeCommand<T>(command: string, callback?: (value: T) => void): void;

    interface DocumentOrShadowRoot {
        getSelection(): Selection | null;
    }
}

export {};
